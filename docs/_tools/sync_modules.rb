# Copies the docs/ folder of each sibling module into this site.
#
# Sibling modules are the entries in _data/menus.yml whose `repo` differs from
# `repository` in _config.yml. For a module keyed SCA with commands collection SCA:
#
#   <sibling>/docs/collections/_commands/*  ->  docs/collections/_SCA/
#   <sibling>/docs/* (everything else)      ->  docs/SCA/
#
# Copied folders are replaced on every run and git-ignored.
#
# With --preview, local IdentityCommand.<Name> clones that are not yet in
# _data/menus.yml are also copied, and _config.preview.yml is written with the
# collections, defaults and menu entries they need. Serve with:
#   bundle exec jekyll serve --config _config.yml,_config.preview.yml
# A run without --preview removes the preview modules and config.
#
# Usage (from docs/):
#   ruby _tools/sync_modules.rb                      # local clones in ../.. (sibling folders of this repo)
#   ruby _tools/sync_modules.rb --source C:/GitHub   # local clones in another folder
#   ruby _tools/sync_modules.rb --suffix -docs-site  # local clones named e.g. IdentityCommand.SCA-docs-site
#   ruby _tools/sync_modules.rb --branch docs-site   # shallow clone each repo's branch from GitHub
#   ruby _tools/sync_modules.rb --preview            # also include unlisted local modules

require "fileutils"
require "optparse"
require "tmpdir"
require "yaml"

SITE_ROOT = File.expand_path("..", __dir__)
PREVIEW_CONFIG = File.join(SITE_ROOT, "_config.preview.yml")
SKIP = %w[collections _config.yml Gemfile Gemfile.lock _site .jekyll-cache vendor].freeze

options = { source: File.expand_path("../..", SITE_ROOT) }
OptionParser.new do |o|
  o.on("--source DIR", "Folder containing local clones of the sibling repos") { |v| options[:source] = File.expand_path(v) }
  o.on("--suffix SUFFIX", "Suffix of local clone folder names, e.g. for worktrees") { |v| options[:suffix] = v }
  o.on("--branch BRANCH", "Clone this branch of each sibling repo from GitHub") { |v| options[:branch] = v }
  o.on("--preview", "Also include local IdentityCommand.* clones not listed in _data/menus.yml") { options[:preview] = true }
end.parse!

config = YAML.safe_load_file(File.join(SITE_ROOT, "_config.yml"))
menus = YAML.safe_load_file(File.join(SITE_ROOT, "_data", "menus.yml"))
siblings = menus.select { |_, m| m["repo"] && m["repo"] != config["repository"] }
owner = config["repository"].split("/").first

def replace_dir(path)
  FileUtils.rm_rf(path)
  FileUtils.mkdir_p(path)
  File.write(File.join(path, ".gitignore"), "*\n")
end

def clone_docs(repo, branch, into)
  url = "https://github.com/#{repo}.git"
  system("git", "clone", "--quiet", "--depth", "1", "--branch", branch, "--filter=blob:none", "--sparse", url, into, exception: true)
  system("git", "-C", into, "sparse-checkout", "set", "docs", exception: true)
end

def copy_docs(name, collection, docs)
  pages_dest = File.join(SITE_ROOT, name)
  replace_dir(pages_dest)
  Dir.children(docs).reject { |c| SKIP.include?(c) || c.start_with?(".") }.each do |child|
    FileUtils.cp_r(File.join(docs, child), pages_dest)
  end

  commands_dest = File.join(SITE_ROOT, "collections", "_#{collection}")
  replace_dir(commands_dest)
  FileUtils.cp(Dir.glob(File.join(docs, "collections", "_commands", "*.md")), commands_dest)

  # A UTF-8 BOM hides front matter from Jekyll
  Dir.glob(File.join("{#{pages_dest},#{commands_dest}}", "**", "*.md")).each do |md|
    text = File.binread(md)
    File.binwrite(md, text.byteslice(3..)) if text.start_with?("\xEF\xBB\xBF".b)
  end

  puts "#{name}: #{Dir.glob(File.join(commands_dest, '*.md')).size} commands from #{docs}"
end

# Longest noun prefix shared by every command that ends on a word boundary, e.g. SCA
def command_prefix(commands)
  nouns = commands.map { |c| c.split("-", 2).last }
  prefix = nouns.reduce { |a, b| a[0, a.chars.zip(b.chars).take_while { |x, y| x == y }.size] }
  prefix = prefix.chop until prefix.empty? || nouns.all? { |n| n[prefix.length].to_s.match?(/[A-Z]/) }
  prefix
end

def preview_module(name, repo, docs)
  commands = Dir.glob(File.join(docs, "collections", "_commands", "*.md")).map { |f| File.basename(f, ".md") }.sort
  psd1 = Dir.glob(File.join(docs, "..", "*", "*.psd1")).first
  description = psd1 && File.read(psd1)[/^\s*Description\s*=\s*['"](.+?)['"]/, 1]
  images = Dir.glob(File.join(docs, "media", "images", "*.png"))
  image = images.find { |i| File.basename(i) == "#{File.basename(repo)}.png" } || images.first
  items = [["Overview", "index.md", "/#{name}/"], ["Getting Started", "getting-started.md", "/#{name}/getting-started/"]]
          .select { |_, file, _| File.exist?(File.join(docs, file)) }
          .map { |label, _, link| { "name" => label, "link" => link } }
  items << { "name" => "Commands", "link" => "/#{name}/commands/" }

  {
    "label"       => File.basename(repo),
    "repo"        => repo,
    "commands"    => name,
    "prefix"      => command_prefix(commands),
    "pinned"      => commands.grep(/\AConnect-|\ANew-\w*Session\z/),
    "description" => description,
    "image"       => image && "/#{name}/media/images/#{File.basename(image)}",
    "menu"        => [{ "label" => File.basename(repo), "items" => items }]
  }.compact
end

if File.exist?(PREVIEW_CONFIG)
  YAML.safe_load_file(PREVIEW_CONFIG).fetch("preview_modules", {}).each_key do |name|
    FileUtils.rm_rf([File.join(SITE_ROOT, name), File.join(SITE_ROOT, "collections", "_#{name}")])
  end
  FileUtils.rm_f(PREVIEW_CONFIG)
end

Dir.mktmpdir do |tmp|
  siblings.each do |name, menu|
    repo_dir =
      if options[:branch]
        File.join(tmp, name).tap { |dir| clone_docs(menu["repo"], options[:branch], dir) }
      else
        File.join(options[:source], "#{File.basename(menu['repo'])}#{options[:suffix]}")
      end
    docs = File.join(repo_dir, "docs")

    unless Dir.exist?(docs)
      warn "#{name}: no docs folder at #{docs}"
      exit 1 if options[:branch]
      next
    end

    copy_docs(name, menu["commands"], docs)
  end
end

exit unless options[:preview]

listed = menus.values.map { |m| File.basename(m["repo"].to_s) }
preview = {}
Dir.glob(File.join(options[:source], "IdentityCommand.*")).sort.each do |dir|
  repo_name = File.basename(dir)
  name = repo_name[/\AIdentityCommand\.([A-Za-z0-9]+)\z/, 1]
  docs = File.join(dir, "docs")
  next unless name && !listed.include?(repo_name) && Dir.exist?(File.join(docs, "collections", "_commands"))

  copy_docs(name, name, docs)
  preview[name] = preview_module(name, "#{owner}/#{repo_name}", docs)
end

defaults = config.fetch("defaults", []) + preview.keys.flat_map do |name|
  [
    { "scope" => { "path" => name }, "values" => { "menubar" => name } },
    { "scope" => { "path" => "", "type" => name },
      "values" => { "render_with_liquid" => false, "layout" => "command", "menubar" => name } }
  ]
end

File.write(PREVIEW_CONFIG, <<~HEADER + YAML.dump(
  # Generated by _tools/sync_modules.rb --preview. Not committed.
HEADER
  "collections"     => preview.keys.to_h { |name| [name, { "output" => true, "permalink" => "/#{name}/commands/:title/" }] },
  "defaults"        => defaults,
  "preview_modules" => preview
))
puts "Wrote #{File.basename(PREVIEW_CONFIG)} for #{preview.size} preview modules"

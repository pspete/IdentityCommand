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
# Usage (from docs/):
#   ruby _tools/sync_modules.rb                      # local clones in ../.. (sibling folders of this repo)
#   ruby _tools/sync_modules.rb --source C:/GitHub   # local clones in another folder
#   ruby _tools/sync_modules.rb --suffix -docs-site  # local clones named e.g. IdentityCommand.SCA-docs-site
#   ruby _tools/sync_modules.rb --branch docs-site   # shallow clone each repo's branch from GitHub

require "fileutils"
require "optparse"
require "tmpdir"
require "yaml"

SITE_ROOT = File.expand_path("..", __dir__)
SKIP = %w[collections _config.yml Gemfile Gemfile.lock _site .jekyll-cache vendor].freeze

options = { source: File.expand_path("../..", SITE_ROOT) }
OptionParser.new do |o|
  o.on("--source DIR", "Folder containing local clones of the sibling repos") { |v| options[:source] = File.expand_path(v) }
  o.on("--suffix SUFFIX", "Suffix of local clone folder names, e.g. for worktrees") { |v| options[:suffix] = v }
  o.on("--branch BRANCH", "Clone this branch of each sibling repo from GitHub") { |v| options[:branch] = v }
end.parse!

config = YAML.safe_load_file(File.join(SITE_ROOT, "_config.yml"))
menus = YAML.safe_load_file(File.join(SITE_ROOT, "_data", "menus.yml"))
siblings = menus.select { |_, m| m["repo"] && m["repo"] != config["repository"] }

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

    pages_dest = File.join(SITE_ROOT, name)
    replace_dir(pages_dest)
    Dir.children(docs).reject { |c| SKIP.include?(c) || c.start_with?(".") }.each do |child|
      FileUtils.cp_r(File.join(docs, child), pages_dest)
    end

    commands_src = File.join(docs, "collections", "_commands")
    commands_dest = File.join(SITE_ROOT, "collections", "_#{menu['commands']}")
    replace_dir(commands_dest)
    FileUtils.cp(Dir.glob(File.join(commands_src, "*.md")), commands_dest)

    # A UTF-8 BOM hides front matter from Jekyll
    Dir.glob(File.join("{#{pages_dest},#{commands_dest}}", "**", "*.md")).each do |md|
      text = File.binread(md)
      File.binwrite(md, text.byteslice(3..)) if text.start_with?("\xEF\xBB\xBF".b)
    end

    puts "#{name}: #{Dir.glob(File.join(commands_dest, '*.md')).size} commands from #{docs}"
  end
end

# Release notes.
#
# Posts in collections/_posts belong to the module whose repo is `repository` in
# _config.yml; posts in collections/_posts/<Module>/ (copied by
# _tools/sync_modules.rb) belong to that sibling module. Each post is published
# at /<Module>/releases/:slug/ (or /releases/:slug/ for this repo's module) with
# its date and version as subtitle. A post with a `version` is also reachable at
# /<Module>/releases/<major.minor>/ and /<Module>/releases/<version>/, which
# redirect to it.
#
# A module with posts gets a release notes index page at /<Module>/releases/ and
# a "Release Notes" sidebar menu item. /releases/all/ lists every module's posts.
module IdentityCommandDocs
  module Releases
    ALL = "/releases/all/".freeze

    def self.root_key(site)
      site.data["menus"].find { |_, m| m["repo"] == site.config["repository"] }&.first
    end

    def self.module_key(site, post)
      parts = post.relative_path.split("/")
      parts[(parts.index("_posts") + 1)...-1].first || root_key(site)
    end

    def self.base(site, key)
      site.data["menus"][key]["menu"][0]["items"][0]["link"].chomp("/")
    end

    def self.subtitle(post)
      date = post.date.strftime("%-d %B %Y")
      post.data["version"] ? "Version #{post.data['version']} - #{date}" : date
    end

    def self.version_aliases(post)
      version = post.data["version"].to_s
      return [] if version.empty?

      [version.split(".").first(2).join("."), version].uniq
    end

    def self.add_menu_item(site, key)
      menu = site.data["menus"][key]
      first, *rest = menu["menu"]
      item = { "name" => "Release Notes", "link" => "#{base(site, key)}/releases/" }
      site.data["menus"][key] = menu.merge("menu" => [first.merge("items" => first["items"] + [item]), *rest])
    end

    def self.page(site, dir, data)
      Jekyll::PageWithoutAFile.new(site, site.source, dir, "index.html").tap { |p| p.data.merge!(data) }
    end

    def self.redirect(site, dir, target)
      url = target.url
      absolute = "#{site.config['url']}#{site.baseurl}#{url}"
      page(site, dir, "layout" => nil, "sitemap" => false).tap do |p|
        p.content = <<~HTML
          <!DOCTYPE html>
          <html lang="#{site.config['lang']}">
          <meta charset="utf-8">
          <title>#{target.data['title']}</title>
          <link rel="canonical" href="#{absolute}">
          <meta http-equiv="refresh" content="0; url=#{site.baseurl}#{url}">
          <meta name="robots" content="noindex">
          <a href="#{site.baseurl}#{url}">#{target.data['title']}</a>
          </html>
        HTML
      end
    end
  end

  Jekyll::Hooks.register :site, :post_read, priority: :low do |site|
    keys = site.posts.docs.filter_map do |post|
      key = Releases.module_key(site, post)
      next unless site.data["menus"][key]

      post.data["menubar"] = key
      post.data["layout"] = "page"
      post.data["subtitle"] ||= Releases.subtitle(post)
      post.data["permalink"] = "#{Releases.base(site, key)}/releases/:slug/"
      key
    end
    keys.uniq.each { |key| Releases.add_menu_item(site, key) }
  end

  class ReleasePageGenerator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      posts = site.posts.docs.select { |post| site.data["menus"][post.data["menubar"]] }
      return if posts.empty?

      taken = site.pages.map(&:url) + posts.map(&:url)
      posts.group_by { |post| post.data["menubar"] }.each do |key, module_posts|
        menu = site.data["menus"][key]
        releases = "#{Releases.base(site, key)}/releases/"
        site.pages << Releases.page(site, releases, "layout" => "releases", "title" => "#{menu['label'] || key} Release Notes",
                                                    "menubar" => key, "hide_hero" => true)

        module_posts.sort_by(&:date).reverse_each do |post|
          Releases.version_aliases(post).each do |version|
            dir = "#{releases}#{version}/"
            next if taken.include?(dir)

            taken << dir
            site.pages << Releases.redirect(site, dir, post)
          end
        end
      end

      site.pages << Releases.page(site, Releases::ALL, "layout" => "releases", "title" => "All Release Notes",
                                                       "menubar" => Releases.root_key(site), "hide_hero" => true, "all" => true)
    end
  end
end

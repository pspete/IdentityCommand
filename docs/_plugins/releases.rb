# Release notes.
#
# Posts in collections/_posts belong to the module whose repo is `repository` in
# _config.yml; posts in collections/_posts/<Module>/ (copied by
# _tools/sync_modules.rb) belong to that sibling module. Each post is published
# at /<Module>/releases/:slug/ (or /releases/:slug/ for this repo's module) with
# its date and version as subtitle. A module with posts gets a release notes
# index page at /<Module>/releases/ and a "Release Notes" sidebar menu item.
module IdentityCommandDocs
  module Releases
    def self.module_key(site, post)
      parts = post.relative_path.split("/")
      folder = parts[(parts.index("_posts") + 1)...-1].first
      folder || site.data["menus"].find { |_, m| m["repo"] == site.config["repository"] }&.first
    end

    def self.base(site, key)
      site.data["menus"][key]["menu"][0]["items"][0]["link"].chomp("/")
    end

    def self.subtitle(post)
      date = post.date.strftime("%-d %B %Y")
      post.data["version"] ? "Version #{post.data['version']} - #{date}" : date
    end

    def self.add_menu_item(site, key)
      menu = site.data["menus"][key]
      first, *rest = menu["menu"]
      item = { "name" => "Release Notes", "link" => "#{base(site, key)}/releases/" }
      site.data["menus"][key] = menu.merge("menu" => [first.merge("items" => first["items"] + [item]), *rest])
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

  class ReleaseIndexGenerator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      site.posts.docs.map { |post| post.data["menubar"] }.uniq.each do |key|
        menu = site.data["menus"][key]
        next unless menu

        page = Jekyll::PageWithoutAFile.new(site, site.source, "#{Releases.base(site, key)}/releases/", "index.html")
        page.data.merge!(
          "layout"    => "releases",
          "title"     => "#{menu['label'] || key} Release Notes",
          "menubar"   => key,
          "hide_hero" => true
        )
        site.pages << page
      end
    end
  end
end

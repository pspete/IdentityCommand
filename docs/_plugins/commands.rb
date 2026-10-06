# Command help pages and per-module command index pages.
#
# Every collection referenced by a `commands` key in _data/menus.yml holds
# platyPS command help. Those documents are titled with their file name
# (e.g. Get-IDUser), and an index page is generated at the collection's
# permalink root (e.g. /SCA/commands/) unless a page already exists there.
module IdentityCommandDocs
  def self.command_collections(site)
    site.data.fetch("menus", {}).filter_map do |module_name, menu|
      collection = site.collections[menu["commands"].to_s]
      [module_name, menu, collection] if collection
    end
  end

  Jekyll::Hooks.register :site, :post_read do |site|
    IdentityCommandDocs.command_collections(site).each do |_, _, collection|
      collection.docs.each do |doc|
        doc.data["title"] = doc.basename_without_ext unless doc.data.key?("title")
      end
    end
  end

  class CommandIndexGenerator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      existing = site.pages.map(&:url)
      IdentityCommandDocs.command_collections(site).each do |module_name, menu, collection|
        dir = collection.metadata["permalink"].to_s.sub(":title/", "")
        next if dir.empty? || existing.include?(dir)

        page = Jekyll::PageWithoutAFile.new(site, site.source, dir, "index.html")
        page.data.merge!(
          "layout"     => "commands",
          "title"      => "#{menu['label'] || module_name} Commands",
          "menubar"    => module_name,
          "collection" => collection.label,
          "hide_hero"  => true
        )
        site.pages << page
      end
    end
  end
end

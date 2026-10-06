# Command help pages and per-module command index pages.
#
# Every collection referenced by a `commands` key in _data/menus.yml holds
# platyPS command help. Those documents are titled with their file name
# (e.g. Get-IDUser) and given a `menu_order`: the module's `pinned` commands
# first, then the rest by noun and verb so companion commands sit together.
# An index page is generated at the collection's permalink root
# (e.g. /SCA/commands/) unless a page already exists there.
module IdentityCommandDocs
  def self.command_collections(site)
    site.data.fetch("menus", {}).filter_map do |module_name, menu|
      collection = site.collections[menu["commands"].to_s]
      [module_name, menu, collection] if collection
    end
  end

  Jekyll::Hooks.register :site, :post_read do |site|
    IdentityCommandDocs.command_collections(site).each do |_, menu, collection|
      pinned = Array(menu["pinned"])
      collection.docs.each { |doc| doc.data["title"] = doc.basename_without_ext }
      ordered = collection.docs.sort_by do |doc|
        verb, noun = doc.data["title"].downcase.split("-", 2)
        [pinned.index(doc.data["title"]) || pinned.size, noun.to_s, verb]
      end
      ordered.each_with_index { |doc, i| doc.data["menu_order"] = i }
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

  module Filters
    # Strips a command prefix from a noun and allows line breaks between its words:
    # "SIAConnectorMaintenanceMode" | noun_heading: "SIA" => "Connector<wbr>Maintenance<wbr>Mode"
    def noun_heading(noun, prefix = nil)
      noun = noun.to_s
      noun = noun.delete_prefix(prefix.to_s) if prefix && noun.length > prefix.to_s.length
      noun.gsub(/(?<=[a-z])(?=[A-Z])/, "<wbr>")
    end
  end
end

Liquid::Template.register_filter(IdentityCommandDocs::Filters)

require File.dirname(__FILE__) + '/lib/wiki_links_hook_listener'

Rails.application.config.after_initialize do
  unless WikiContent.included_modules.include?(WikiLinksWikiContentPatch)
    WikiContent.send(:include, WikiLinksWikiContentPatch)
  end
  unless WikiContent.included_modules.include?(WikiLinksWikiPagePatch)
    WikiPage.send(:include, WikiLinksWikiPagePatch)
  end
  unless WikiContent.included_modules.include?(WikiLinksWikiPatch)
    Wiki.send(:include, WikiLinksWikiPatch)
  end
end

Redmine::Plugin.register :redmine_wiki_backlinks do
  name 'Redmine Wiki Backlinks plugin'
  author 'EEA'
  description 'Provides reports with backlinks, orphan pages and wanted pages for Redmine wikis'
  version '0.1.0'
  url 'http://github.com/eea/redmine_wiki_backlinks'

  # Add the permission to the Wiki module
  project_module :wiki do
    permission :view_wiki_links, {
      :wiki_links => [:links_to, :links_from,:orphan, :wanted]
    }, :read => true
  end

  requires_redmine :version_or_higher => '2.2'

  menu :admin_menu,
       :wiki_links,
       { :controller => 'wiki_links', :action => 'index'},
       :caption => :label_admin_wiki_links

end

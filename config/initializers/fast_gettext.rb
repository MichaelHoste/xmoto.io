FastGettext.add_text_domain 'xmoto', :path => 'config/gettext_locales', :type => :po
FastGettext.default_available_locales = ['en', 'fr'] # all you want to allow
FastGettext.default_text_domain = 'xmoto'
GettextI18nRails.translations_are_html_safe = true

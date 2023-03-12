require 'dev'

module Dev
    class Default
        SECTION = "default"

        def self.github_root
            @@github_root ||= Dev::Config.get(SECTION, "github_root") || "~/src/github.com/"
        end

        def self.account
            account = Dev::Config.get(SECTION, 'account')
            raise(Abort, "account/repo both required unless #{SECTION}.account is set in config") unless account
            account
        end
    end
end

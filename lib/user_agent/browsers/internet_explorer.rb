class UserAgent
  module Browsers
    module InternetExplorer
      def self.extend?(agent)
        agent.application &&
          agent.application.comment &&
          agent.application.comment[0] == "compatible" &&
          agent.application.comment[1] =~ /MSIE/
      end

      def browser
        if detect_comment('360SE')
          '360SE'
        elsif detect_comment('360EE')
          '360EE'
        elsif detect_comment('SE 2.X MetaSr 1.0')
          'Sogou'
        elsif detect_comment('Maxthon/')
          'Maxthon'
        else
          "Internet Explorer"
        end
      end

      def version
        application.comment[1].sub("MSIE ", "")
      end

      def compatibility
        application.comment[0]
      end

      def compatible?
        compatibility == "compatible"
      end

      # Before version 4.0, Chrome Frame declared itself (unversioned) in a comment;
      # as of 4.0 it can declare itself versioned in a comment
      # or as a separate product with a version

      def chromeframe
        cf = application.comment.include?("chromeframe") || detect_product("chromeframe")
        return cf if cf
        cf_comment = application.comment.detect{|c| c['chromeframe/']}
        cf_comment ? UserAgent.new(*cf_comment.split('/', 2)) : nil
      end

      def platform
        "Windows"
      end

      def os
        OperatingSystems.normalize_os(application.comment[2])
      end
    end
  end
end

module Go
  module Tools
    require "go/tools/base"

    class Subversion < Base
      self.bin = "usr/bin"
      self.executable = "svn"
      self.name = "subversion"
      self.version = "1.6.6"

      deb "http://security.ubuntu.com/ubuntu/pool/main/s/subversion/libsvn1_1.6.6dfsg-2ubuntu1.3_amd64.deb"
      deb "http://security.ubuntu.com/ubuntu/pool/main/s/subversion/subversion_1.6.6dfsg-2ubuntu1.3_amd64.deb"
      deb "http://security.ubuntu.com/ubuntu/pool/main/s/subversion/subversion-tools_1.6.6dfsg-2ubuntu1.3_all.deb"
    end
  end
end

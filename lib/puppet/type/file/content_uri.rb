require 'net/http'
require 'uri'

module Puppet
  Puppet::Type.type(:file).newparam(:content_uri) do

    desc <<-'EOT'
      A unique identifier for file content, which must be a URI that points
      to a file in a module. This parameter allows the content of a file resource
      to remain consistent regardless of changes to file content managed by the puppet
      fileserver.

      NOTE: this parameter is generated by puppet internally, but should never be specified in manifests.

      The normal form of a `puppet:` URI is:

      `puppet:///modules/<MODULE NAME>/files/<FILE PATH>`

       Note that content_uri contains "files" in its path, unlike the source parameter.
    EOT

    validate do |path|
      begin
        uri = URI.parse(URI.escape(path))
      rescue
        self.fail Puppet::Error, "Could not understand URI #{path}: #{detail}", detail
      end

      self.fail "Cannot use opaque URLs '#{source}'" unless uri.hierarchical?

      if uri.scheme != "puppet"
        self.fail "Must use URLs of type puppet as content URI"
      end
    end
  end
end


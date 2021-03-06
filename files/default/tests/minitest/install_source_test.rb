require_relative 'support/test_helper'

describe_recipe 'sbp_packer::install_source' do
  include ChefPacker::TestHelper

  it 'created source dir' do
    skip 'not tested under Windows' if node['platform_family'] == 'windows'
    require 'uri'

    uri = URI.parse(node['packer']['source_repo_url'])
    src_dir = "#{node['go']['gopath']}/src/#{uri}".gsub('.git', '')
    directory(src_dir)
      .must_exist
      .with(:mode, '755')
      .and(:owner, 'root')
      .and(:group, 'root')
  end

  it 'symlink executable' do
    directory('/usr/local/bin').must_exist
    link('/usr/local/bin/packer')
      .must_exist
      .with(:to, "#{src_dir}/packer")
  end
end

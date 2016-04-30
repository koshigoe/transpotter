require_relative '../spec_helper'

RSpec.describe 'ftp role', type: :serverspec do
  it_behaves_like 'ProFTPD'
end

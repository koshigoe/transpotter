require_relative '../spec_helper'

RSpec.describe 'ftp role', type: :serverspec do
  it_behaves_like 'ProFTPD'
  it_behaves_like 'Git'
  it_behaves_like 'Ruby'
end

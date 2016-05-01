require_relative '../spec_helper'

RSpec.describe 'api role', type: :serverspec do
  it_behaves_like 'Git'
  it_behaves_like 'Ruby'
end

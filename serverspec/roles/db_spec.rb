require_relative '../spec_helper'

RSpec.describe 'db role', type: :serverspec do
  it_behaves_like 'PostgreSQL'
end

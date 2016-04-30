# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`id`**               | `integer`          | `not null, primary key`
# **`username`**         | `string`           | `not null`
# **`password_digest`**  | `string`           | `not null`
#
# ### Indexes
#
# * `idx_users_name` (_unique_):
#     * **`username`**
#

require 'rails_helper'

RSpec.describe User, :type => :model do
  let(:user) { create(:user) }

  describe '#token' do
    subject { user.token }

    let(:now) { Time.local(2015, 1, 1, 0, 0) }

    around do |example|
      travel_to now do
        example.run
      end
    end

    it 'is JWT token' do
      payload, header = JWT.decode(subject, user.password_digest)
      expect(header).to eq({ 'typ' => 'JWT', 'alg' => 'HS256' })

      expected_payload = {
        'sub' => user.id.to_s,
        'aud' => user.id.to_s,
        'iat' => Time.local(2015, 1, 1, 0, 0).to_i,
        'exp' => Time.local(2015, 1, 2, 0, 0).to_i,
      }
      expect(payload).to eq(payload)
    end
  end
end

class User < ApplicationRecord
  enum external_provider: { google: :google }
end

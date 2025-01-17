# spec/swagger_helper.rb
require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Better API V1',
        version: 'v1'
      },
      components: {
        schemas: {
          user: {
            type: :object,
            properties: {
              id: { type: :integer },
              email: { type: :string },
              username: { type: :string },
              balance: { type: :number },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            }
          },
          bet: {
            type: :object,
            properties: {
              id: { type: :integer },
              user_id: { type: :integer },
              game_id: { type: :integer },
              amount: { type: :number },
              odds: { type: :number },
              pick: { type: :string },
              status: { type: :string },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            }
          },
          game: {
            type: :object,
            properties: {
              id: { type: :integer },
              home_team: { type: :string },
              away_team: { type: :string },
              status: { type: :string },
              created_at: { type: :string, format: :datetime },
              updated_at: { type: :string, format: :datetime }
            }
          }
        },
        securitySchemes: {
          bearer_auth: {
            type: :http,
            scheme: :bearer,
            bearer_format: 'JWT'
          }
        }
      }
    }
  }
end
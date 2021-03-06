RSpec.describe 'Programming languages endpoints', type: :request do
  context 'GET index' do
    context 'when there are no programming languages' do
      it 'returns an empty list' do
        get '/api/v1/programming_languages'

        expect(JSON.parse(response.body)).to be_empty
      end
    end

    context 'when there are programming languages' do
      before do
        create(:programming_language, name: 'Ruby', release_year: '1995', creator: 'Matz')
        create(:programming_language, name: 'Lisp', release_year: '1958', creator: 'John McCarthy')
      end

      it 'returns 2 items' do
        get '/api/v1/programming_languages'

        expect(JSON.parse(response.body).count).to eq(2)
      end

      it 'returns a list' do
        get '/api/v1/programming_languages'

        expect(JSON.parse(response.body).map(&:symbolize_keys).first).to include(
          name: 'Lisp',
          release_year: 1958,
          creator: 'John McCarthy'
        )

        expect(JSON.parse(response.body).map(&:symbolize_keys).last).to include(
          name: 'Ruby',
          release_year: 1995,
          creator: 'Matz'
        )
      end

      it 'returns the correct HTTP status' do
        get '/api/v1/programming_languages'

        expect(response).to have_http_status(:ok)
      end

      it 'returns the correct content_type' do
        get '/api/v1/programming_languages'

        expect(response.content_type).to eq('application/json')
      end
    end
  end

  context 'POST create' do
    it 'creates a post' do
      expect do
        post '/api/v1/programming_languages', params: {
          programming_language: {
            name: 'Ruby',
            release_year: '1995',
            creator: 'Matz'
          }
        }
      end.to change(ProgrammingLanguage, :count).by(1)
    end

    # TODO: create spec to make sure the proper attributes are being set

    it 'returns the correct HTTP status' do
      post '/api/v1/programming_languages', params: {
        programming_language: attributes_for(:programming_language)
      }

      expect(response).to have_http_status(:created)
    end

    it 'returns the correct content_type' do
      post '/api/v1/programming_languages', params: {
        programming_language: attributes_for(:programming_language)
      }

      expect(response.content_type).to eq('application/json')
    end
  end
end

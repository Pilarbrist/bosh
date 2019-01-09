require 'bosh/template/evaluation_context'
require_relative './template_example_group'

describe 'write_users.erb' do
  context 'blobstore with single users settings' do
    it_should_behave_like 'a rendered file' do
      let(:file_name) { '../jobs/blobstore/templates/write_users.erb' }
      let(:properties) do
        {
          'properties' => {
            'blobstore' => {
              'agent' => {
                'user' => 'agent-0',
                'password' => 'uyerbvfg84357gf43u',
              },
              'director' => {
                'user' => 'director-0',
                'password' => 'oeuirgh9453yt44y98',
              },
            }
          }
        }
      end
      let(:expected_content) do
        <<~HEREDOC
agent-0:{PLAIN}uyerbvfg84357gf43u
director-0:{PLAIN}oeuirgh9453yt44y98
        HEREDOC
      end
    end
  end

  context 'blobstore with multiple users settings' do
    it_should_behave_like 'a rendered file' do
      let(:file_name) { '../jobs/blobstore/templates/write_users.erb' }
      let(:properties) do
        {
          'properties' => {
            'blobstore' => {
              'agent' => {
                'user' => 'agent-0',
                'password' => 'uyerbvfg84357gf43u',
                'additional_users' => [
                  {
                    'user' => 'agent-1',
                    'password' => '87y34tfgbyt4f487'
                  },
                  {
                    'user' => 'agent-2',
                    'password' => '78y4rfehg4f7834g'
                  },
                ],
              },
              'director' => {
                'user' => 'director-0',
                'password' => 'oeuirgh9453yt44y98',
              },
            }
          }
        }
      end
      let(:expected_content) do
        <<~HEREDOC
agent-0:{PLAIN}uyerbvfg84357gf43u
director-0:{PLAIN}oeuirgh9453yt44y98
agent-1:{PLAIN}87y34tfgbyt4f487
agent-2:{PLAIN}78y4rfehg4f7834g
        HEREDOC
      end
    end
  end

end

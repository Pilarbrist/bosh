require 'spec_helper'

module Bosh::Director
  describe RuntimeConfig::RuntimeManifestResolver do
    let(:raw_runtime_config_manifest) do
      {
        'releases' => [
          {'name' => 'release_1', 'version' => 'v1'},
          {'name' => 'release_2', 'version' => 'v2'}
        ],
        'addons' => [
          {
            'name' => 'logs',
            'jobs' => [
              {
                  'name' => 'mysql',
                  'template' => 'template1',
                  'properties' => {
                      'foo' => 'foo_value',
                      'bar' => {
                          'smurf' => 'blue',
                      },
                  },
                  'consumes' => {
                      'db' => {
                          'type' => '((interpolated_type))',
                          'properties' => {
                              'bar' => {
                                  'smurf' => 'blue',
                              },
                              'interpolate' => '((valuable))',
                          },
                      },
                  },
              },
              {
                  'name' => '((job_name))',
                  'template' => 'template1',
              },
            ],
            'properties' => {'a' => ['123', 45, '((secret_key))']}
          }
        ],
      }
    end

    describe '#resolve_manifest' do
      context 'when config server is enabled' do
        let(:client_factory) { double(Bosh::Director::ConfigServer::ClientFactory) }
        let(:config_server_client) { double(Bosh::Director::ConfigServer::Client) }

        let(:ignored_subtrees) do
          index_type = Integer

          ignored_subtrees = []
          ignored_subtrees << ['addons', index_type, 'properties']
          ignored_subtrees << ['addons', index_type, 'jobs', index_type, 'properties']
          ignored_subtrees << ['addons', index_type, 'jobs', index_type, 'consumes', String, 'properties']
          ignored_subtrees
        end

        before do
          allow(Bosh::Director::ConfigServer::ClientFactory).to receive(:create).and_return(client_factory)
          allow(client_factory).to receive(:create_client).and_return(config_server_client)
        end

        it 'calls the client with correct parameters' do
          expect(config_server_client).to receive(:interpolate).with(raw_runtime_config_manifest, ignored_subtrees)

          Bosh::Director::RuntimeConfig::RuntimeManifestResolver.resolve_manifest(raw_runtime_config_manifest)
        end
      end
    end
  end
end

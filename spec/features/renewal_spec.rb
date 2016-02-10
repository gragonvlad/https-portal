require 'spec_helper'

RSpec.describe 'Renewal', composition: 'minimal-setup' do

  let(:docker_command) { 'docker exec portalspec_https-portal_1 bash -c ' +
                         "'test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )'" }

  context 'when certs already signed and no FORCE_RENEW specified' do
    it 'should not renew certs' do
      docker_compose :up

      output = `#{docker_command}`

      expect(output).to include "No need to renew certs for #{ENV['TEST_DOMAIN']}"
    end
  end

  context 'when certs already signed and FORCE_RENEW specified' do
    it 'should force renew the certs' do
      docker_compose :up, env: { 'FORCE_RENEW' => 'true' }

      output = `#{docker_command}`

      expect(output).to include "Renewed certs for #{ENV['TEST_DOMAIN']}"
    end
  end
end

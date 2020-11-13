control 'service' do
  describe service 'transmission-daemon' do
    it { should be_enabled }
    it { should be_running }
  end
end

control 'ports' do
  describe port 9091 do
    it { should be_listening }
  end

  describe port 51413 do
    it { should be_listening }
  end

  describe http('http://localhost:9091', auth: { user: 'transmission', pass: 'changeme' }) do
    its('status') { should cmp 301 }
    its('headers.location') { should cmp '/transmission/web/' }
  end
end

control 'cli' do
  describe command 'transmission-remote -n transmission:changeme -l' do
    its('exit_status') { should eq 0 }
    its('stdout') { should match /ID\s+Done\s+Have\s+ETA/ }
  end
end

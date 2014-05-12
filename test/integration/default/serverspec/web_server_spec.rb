require 'spec_helper'

describe package('httpd'), :if => property[:os][:family] == 'RedHat' do
  it 'is installed' do
    expect(subject).to be_installed
  end
end

describe package('apache2'),
  :if => property[:os][:family] == 'Ubuntu' ||  property[:os][:family] == 'Debian' do
  it 'is installed' do
    expect(subject).to be_installed
  end
end

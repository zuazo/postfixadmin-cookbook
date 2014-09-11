# encoding: UTF-8

require 'spec_helper'

describe package('httpd'), if: property[:os][:family] == 'RedHat' do
  it 'is installed' do
    expect(subject).to be_installed
  end
end

describe package('apache2'),
         if: %w(Ubuntu Debian).include?(property[:os][:family]) do
  it 'is installed' do
    expect(subject).to be_installed
  end
end

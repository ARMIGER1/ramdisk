require "spec_helper"
require "fileutils"

RSpec.describe Ramdisk::Mac do
  it "has a default sector size" do
    expect(Ramdisk::Mac.sector_size).to eq(512)
  end

  it "has a default name" do
    ramdisk = Ramdisk::Mac.new

    expect(ramdisk.disk_name).to eq("RAMDISK")
  end

  it "allows the disk name to be set on initialize" do
    disk_name = "Example disk"
    ramdisk = Ramdisk::Mac.new(disk_name: disk_name)

    expect(ramdisk.disk_name).to eq(disk_name)
  end

  describe '#disk_size' do
    it "calculates the size of the new disk in bytes" do
      ramdisk = Ramdisk::Mac.new

      # Defaults to 2GB
      expect(ramdisk.disk_size).to eq(4194304)
    end

    [[0.5, 1048576], [1, 2097152],[1.5, 3145728]].each do |size|
      it "calculates the size of a #{size[0]}GB disk in bytes" do
        gb_value = size[0]
        byte_value = size[1]
        ramdisk = Ramdisk::Mac.new(disk_size_in_gb: gb_value)

        expect(ramdisk.disk_size).to eq(byte_value)
      end
    end
  end

  describe '#create' do
    mount_point = '/Volumes/RAMDISK'

    before(:all) do
      FileUtils.mkdir(mount_point) unless File.exist?(mount_point)
    end

    after(:all) do
      FileUtils.rm_rf(mount_point)
    end

    before(:each) do
      @ramdisk = Ramdisk::Mac.new(disk_size_in_gb: 2)
    end

    it 'creates a ramdisk in /dev' do
      @ramdisk.create

      expect(@ramdisk.location).not_to be_nil
      expect(@ramdisk.location).not_to eq('')

      # puts `diskutil list`

      @ramdisk.destroy
    end
  end

  describe '#for_ios_simulator' do
    it "configures the ramdisk to be used with the given XCode project's iOS Simulator device" do
      ios_ramdisk = Ramdisk::Mac.new
      regex = /[0-9A-F]{,8}-[0-9A-F]{,4}-[0-9A-F]{,4}-[0-9A-F]{,4}-[0-9A-F]{,12}\z/

      ios_ramdisk.for_ios_simulator(app_name: 'RealmAndCharts-example')

      expect(ios_ramdisk.disk_name).to match(regex)
      expect(ios_ramdisk.disk_name.length).to eq(36)
      expect(ios_ramdisk.mount_point).to match(regex)
      expect(ios_ramdisk.mount_point).not_to match(/data/)
      expect(ios_ramdisk.disk_size).to eq(1048576)

      ios_ramdisk.create

      sleep(10)

      ios_ramdisk.destroy
    end
  end

  describe '#for_xcode' do
    it "configures the ramdisk to be used with XCode" do
      xcode_ramdisk = Ramdisk::Mac.new

      xcode_ramdisk.for_xcode

      expect(xcode_ramdisk.disk_name).to eq('DerivedData')
      expect(xcode_ramdisk.mount_point).to eq(File.expand_path('~/Library/Developer/Xcode/DerivedData'))
      expect(xcode_ramdisk.disk_size).to eq(2097152)

      xcode_ramdisk.create

      sleep(10)

      xcode_ramdisk.destroy
    end
  end
end

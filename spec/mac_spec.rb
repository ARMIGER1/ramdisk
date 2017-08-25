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

      puts `diskutil list`

      @ramdisk.destroy
    end
  end
end

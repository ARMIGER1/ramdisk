require "spec_helper"

RSpec.describe Ramdisk::Mac do
  it "has a default sector size" do
    expect(Ramdisk::Mac.sector_size).to eq(512)
  end

  it "has a default name" do
    ramdisk = Ramdisk::Mac.new

    expect(ramdisk.disk_name).to eq("Untitled")
  end

  it "allows the disk name to be set on initialize" do
    disk_name = "Example disk"
    ramdisk = Ramdisk::Mac.new(disk_name: disk_name)

    expect(ramdisk.disk_name).to eq(disk_name)
  end

  describe '#disk_size' do
    it "calculates the size of the new disk in bytes" do
      ramdisk = Ramdisk::Mac.new

      expect(ramdisk.calculate_size(2)).to eq(4194304)
    end
  end
end

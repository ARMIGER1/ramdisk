require "spec_helper"

RSpec.describe Ramdisk::Mac do
  it "has a default sector size" do
    expect(Ramdisk::Mac.sector_size).to eq(512)
  end

  it "has a default name" do
    ramdisk = Ramdisk::Mac.new

    expect(ramdisk.disk_name).to eq("Untitled")
  end
end

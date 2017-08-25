require "spec_helper"

RSpec.describe Ramdisk do
  it "has a version number" do
    expect(Ramdisk::VERSION).not_to be nil
  end

  it "has a default sector size" do
    expect(Ramdisk::DEFAULT_SECTOR_SIZE).to eq(512)
  end
end

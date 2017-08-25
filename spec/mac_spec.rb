require "spec_helper"

RSpec.describe Ramdisk::Mac do
  it "has a default sector size" do
    expect(Ramdisk::Mac.sector_size).to eq(512)
  end
end

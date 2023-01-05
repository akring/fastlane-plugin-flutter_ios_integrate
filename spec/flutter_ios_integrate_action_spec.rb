describe Fastlane::Actions::FlutterIosIntegrateAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The flutter_ios_integrate plugin is working!")

      Fastlane::Actions::FlutterIosIntegrateAction.run(nil)
    end
  end
end

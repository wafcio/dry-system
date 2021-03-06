RSpec.describe Dry::System::Injector do
  before do
    class Test::Container < Dry::System::Container
      configure do |config|
        config.root = SPEC_ROOT.join('fixtures/test').realpath
      end

      load_paths! 'lib'
    end

    Test::Inject = Test::Container.injector
  end

  it 'supports args injection by default' do
    obj = Class.new do
      include Test::Inject['test.dep']
    end.new

    expect(obj.dep).to be_a Test::Dep
  end

  it 'supports args injection with explicit method' do
    obj = Class.new do
      include Test::Inject.args['test.dep']
    end.new

    expect(obj.dep).to be_a Test::Dep
  end

  it 'supports hash injection' do
    obj = Class.new do
      include Test::Inject.hash['test.dep']
    end.new

    expect(obj.dep).to be_a Test::Dep
  end

  it 'support kwargs injection' do
    obj = Class.new do
      include Test::Inject.kwargs['test.dep']
    end.new

    expect(obj.dep).to be_a Test::Dep
  end

  it 'allows injection strategies to be swapped' do
    obj = Class.new do
      include Test::Inject.kwargs.hash['test.dep']
    end.new

    expect(obj.dep).to be_a Test::Dep
  end

  it 'supports aliases' do
    obj = Class.new do
      include Test::Inject['test.dep', foo: 'test.dep']
    end.new

    expect(obj.dep).to be_a Test::Dep
    expect(obj.foo).to be_a Test::Dep
  end

  context 'singleton' do
    it 'supports injection' do
      obj = Class.new do
        include Test::Inject[foo: 'test.singleton_dep']
      end.new

      expect(obj.foo).to be_a Test::SingletonDep
    end
  end
end

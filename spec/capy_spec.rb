require 'spec_helper'

describe Capy do
  before do
    stub(Capy).start_shell.with_any_args
  end

  context '$ capy' do
    it 'start shell' do
      mock(Capy).start_shell.with_any_args
      Capy.run([]).should == 0
    end
  end

  context '$ capy -h' do
    it 'show help' do
      Capy.run(%w(-h)).should == 1
    end
  end

  context '$ capy -b firefox' do

  end

  context '$ capy -a http://google.com/' do
    it 'visit http://google.com/' do
      any_instance_of(Capy::Evaluater) do |evaluater|
        mock(evaluater).visit('http://google.com/')
      end
      mock(Capy).start_shell.with_any_args
      Capy.run(%w(-a http://google.com/)).should == 0
    end
  end

  context '$ capy foo.capy' do
    context 'file is exists' do
      it 'eval script' do
        file = File.expand_path('../fixtures/foo.capy', __FILE__)
        script = File.read(file)
        any_instance_of(Capy::Evaluater) do |evaluater|
          mock(evaluater).eval_script(script, :capybara)
        end
        Capy.run([file]).should == 0
      end
    end

    context 'file is not exists' do
      it 'does not eval script' do
        any_instance_of(Capy::Evaluater) do |evaluater|
          mock(evaluater).eval_script.with_any_args.never
        end
        Capy.run(%w(bar.capy)).should == 1
      end
    end
  end

  context '$ capy foo.capy' do
    it 'eval script and stop' do
      file = File.expand_path('../fixtures/foo.capy', __FILE__)
      any_instance_of(Capy::Evaluater) do |evaluater|
        mock(evaluater).eval_script.with_any_args
      end
      mock(Capy).start_shell.with_any_args
      Capy.run(['-s', file]).should == 0
    end
  end

  context '$ capy -j foo.js' do
    it 'does not eval script' do
      mock(Capy).eval_script_file.with_any_args.never
      Capy.run(%w(-j foo.js)).should == 1
    end
  end

  context '$ capy -j foo.js' do
    context 'file is exists' do
      it 'eval script' do
        file = File.expand_path('../fixtures/foo.js', __FILE__)
        script = File.read(file)
        any_instance_of(Capy::Evaluater) do |evaluater|
          mock(evaluater).eval_script(script, :javascript)
        end
        Capy.run(['-j', file]).should == 0
      end
    end

    context 'file is not exists' do
      it 'does not eval script' do
        mock(Capy).eval_script_file.with_any_args.never
        Capy.run(%w(bar.capy)).should == 1
      end
    end
  end
end

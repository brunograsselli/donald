require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Donald::MergeTool do
  let(:output) { double('output').as_null_object }
  
  before(:each) do
    Kernel.stub!(:system)
  end
    
  context 'with no unmerged files' do
    let(:merge_tool) { Donald::MergeTool.new(output) }
    
    before(:each) do
      git_status_message = status_message_with_no_unmerged_files
    
      merge_tool.stub!(:git_status).and_return(git_status_message)
    end
  
    it 'should send an error message' do
      output.should_receive(:puts).with('No unmerged files found')
    
      merge_tool.start
    end
  end
  
  context 'with unmerged files' do
    before(:each) do
      git_status_message = status_message_with_unmerged_files(
        'unmerged' => 'app/models/post.rb',
        'both modified' => 'app/models/comment.rb',
        'both added' => 'app/models/author.rb')
      merge_tool.stub!(:git_status).and_return(git_status_message)
    end
    
    describe 'with no arguments' do
      let(:merge_tool) { Donald::MergeTool.new(output) }
    
      it 'should call vim' do
        Kernel.should_receive(:system).with('vim -p +/HEAD app/models/author.rb app/models/post.rb app/models/comment.rb')
      
        merge_tool.start
      end
      
      it 'should call textmate with $EDITOR variable setted as "mate"' do
        merge_tool.stub!(:system_editor_variable).and_return('mate')

        Kernel.should_receive(:system).with('mate app/models/author.rb app/models/post.rb app/models/comment.rb')

        merge_tool.start
      end
    end
    
    describe 'with --vim argument' do
      let(:merge_tool) { Donald::MergeTool.new(output, ['--vim']) }
    
      it 'should call gvim even with $EDITOR variable setted to another editor' do
        merge_tool.stub!(:system_editor_variable).and_return('mate')
        
        Kernel.should_receive(:system).with('vim -p +/HEAD app/models/author.rb app/models/post.rb app/models/comment.rb')
      
        merge_tool.start
      end
    end
    
    describe 'with --gvim argument' do
      let(:merge_tool) { Donald::MergeTool.new(output, ['--gvim']) }
    
      it 'should call gvim' do
        Kernel.should_receive(:system).with('gvim -p +/HEAD app/models/author.rb app/models/post.rb app/models/comment.rb')
      
        merge_tool.start
      end
    end
    
    describe 'with -g argument' do
      let(:merge_tool) { Donald::MergeTool.new(output, ['-g']) }
    
      it 'should call gvim' do
        Kernel.should_receive(:system).with('gvim -p +/HEAD app/models/author.rb app/models/post.rb app/models/comment.rb')
      
        merge_tool.start
      end
    end
    
    describe 'with --mvim argument' do
      let(:merge_tool) { Donald::MergeTool.new(output, ['--mvim']) }
    
      it 'should call mvim' do
        Kernel.should_receive(:system).with('mvim -p +/HEAD app/models/author.rb app/models/post.rb app/models/comment.rb')
      
        merge_tool.start
      end
    end
    
    describe 'with -m argument' do
      let(:merge_tool) { Donald::MergeTool.new(output, ['-m']) }
    
      it 'should call mvim' do
        Kernel.should_receive(:system).with('mvim -p +/HEAD app/models/author.rb app/models/post.rb app/models/comment.rb')
      
        merge_tool.start
      end
    end
    
    describe 'with --textmate argument' do
      let(:merge_tool) { Donald::MergeTool.new(output, ['--textmate']) }
    
      it 'should call textmate' do
        Kernel.should_receive(:system).with('mate app/models/author.rb app/models/post.rb app/models/comment.rb')
      
        merge_tool.start
      end
    end
    
    describe 'with -t argument' do
      let(:merge_tool) { Donald::MergeTool.new(output, ['-t']) }
    
      it 'should call textmate' do
        Kernel.should_receive(:system).with('mate app/models/author.rb app/models/post.rb app/models/comment.rb')
      
        merge_tool.start
      end
    end
    
  end
  
end

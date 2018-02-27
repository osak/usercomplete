# -*- coding: utf-8 -*-

Plugin.create(:usercomplete) do
  class CompletionInfo
    attr_reader :insert_pos

    #
    # Constuructor.
    #
    def initialize(insert_pos, prefix)
      @insert_pos = insert_pos
      @list = Plugin.filtering(:user_prefix_search, prefix, [])[1].map{|u| u[:idname]}.sort.freeze
      @cnt = 0

      # State information to determine whether iterating on candidates.
      @last_pos = nil
      @last_completion = nil
    end

    #
    # True if completion commands is invoked successively.
    # Decision is based on last cursor position and
    # last completed word.
    # (This strategy can failure in some situation, 
    #  but I think it is enough for ordinary case.)
    #
    # _pos_ :: current cursor position.
    # _match_str_ :: 
    # 
    def same_state?(pos, match_str)
      pos == @last_pos && match_str == @last_completion
    end

    #
    # Returns currently looking candidate.
    #
    def get_candidate
      if @list.size == 0
        nil
      else
        @list[@cnt].dup
      end
    end

    #
    # Increment (or decrement) counter.
    #
    # _val :: step size.
    #
    def step(val = 1)
      @cnt += val
      @cnt %= @list.size
    end

    #
    # Update state.
    #
    # _last_pos_ :: cursor position after last completion.
    # _last_comp_ :: last completed name.
    def update(last_pos, last_comp)
      @last_pos = last_pos
      @last_completion = last_comp.dup.freeze
    end
  end

  def complete_main(widget, step)
    raw_postbox = Plugin.filtering(:gui_get_gtk_widget, widget).first
    buffer = raw_postbox.widget_post.buffer
    start, last, selected = buffer.selection_bounds
    text = buffer.get_text(nil, start)
    m = text.match(/@([_a-zA-Z0-9]+(?:@[-a-zA-Z0-9\.]+)?)$/)
    if m
      # Check current state.
      # If completion command is invoked multiple times,
      # iterate over candidates.
      if @info.nil? || !@info.same_state?(start.offset, m[1])
        @info = CompletionInfo.new(start.offset - m[1].length, m[1])
      else
        @info.step(step)
      end
      name = @info.get_candidate
      if name
        insert_pos = buffer.get_iter_at_offset(@info.insert_pos)
        buffer.delete(insert_pos, last)
        buffer.insert(insert_pos, name)
        @info.update(buffer.selection_bounds[1].offset, name)
      end
    end
  rescue => e
    Plugin.call(:update, nil, [Mikutter::System::Message.new(description: e.to_s + e.backtrace.join("\n"))])
  end

  command(:usercomplete_forward,
          name: "ユーザー名補完(次)",
          condition: Plugin::Command[:Editable],
          visible: false,
          role: :postbox) do |opt|
    complete_main(opt.widget, 1) end

  command(:usercomplete_backward,
          name: "ユーザー名補完(前)",
          condition: Plugin::Command[:Editable],
          visible: false,
          role: :postbox) do |opt|
    complete_main(opt.widget, -1) end
end

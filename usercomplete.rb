# -*- coding: utf-8 -*-

Plugin.create(:usercomplete) do
  class CompletionInfo
    #
    # Constuructor.
    #
    def initialize(insert_pos, prefix)
      @insert_pos = insert_pos
      @list = Plugin.filtering(:usercomplete, prefix, [])[1].sort.freeze
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
      @list[@cnt].dup
    end

    #
    # Update state.
    #
    # _last_pos_ :: cursor position after last completion.
    # _last_comp_ :: last completed name.
    def update(last_pos, last_comp)
      @cnt += 1
      @cnt %= @list.size
      @last_pos = last_pos
      @last_completion = last_comp.dup.freeze
    end
  end

  command(:usercomplete,
          name: "ユーザー名補完",
          condition: Plugin::Command[:Editable],
          visible: false,
          role: :postbox) do |opt|
    begin
      raw_postbox = Plugin.filtering(:gui_get_gtk_widget, opt.widget).first
      buffer = raw_postbox.widget_post.buffer
      start, last, selected = buffer.selection_bounds
      text = buffer.get_text(nil, start)
      m = text.match(/@([_a-zA-Z0-9]+)$/)
      if m
        # Check current state.
        # If completion command is invoked multiple times,
        # iterate over candidates.
        if @info.nil? || !@info.same_state?(start.offset, m[1])
          @info = StateInfo.new(start.offset - m[1].length, m[1])
        end
        name = @info.get_candidate
        insert_pos = buffer.get_iter_at_offset(@info.insert_pos)
        buffer.delete(insert_pos, last)
        buffer.insert(insert_pos, name)
        @info.update(buffer.selection_bounds[1].offset, name)
      end
    rescue => e
      Plugin.call(:update, nil, [Message.new(message: e.to_s + e.backtrace.join("\n"), system: true)])
    end
  end
end

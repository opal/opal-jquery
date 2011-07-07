class RQuery
  # @group Events

  [:click, :mousedown, :mouseup].each do |evt|
    name = evt.to_s
    define_method(evt) do |&block|
      `var func = function(evt) {
        return #{block.call evt} == Qfalse ? false : true;
      };

      self[name](func);`
      self
    end
  end

  # @endgroup
end

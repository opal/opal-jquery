module RQuery
  class Element

    def html
      `return self.$el.innerHTML;`
    end

    def text
      `var elem = self.$el;
      return elem.textContent ? elem.textContent : elem.innerText;`
    end

    alias_method :inner_html, :html
    alias_method :inner_text, :text

    [:src, :href].each do |a|
      define_method(a) do
        `return self.$el.getAttribute(a.toString(), 2) || nil;`
      end
    end

    [:id, :type].each do |a|
      define_method(a) do
        `return self.$el.getAttribute(a.toString()) || nil;`
      end
    end

    def [](name)
      `return self.$el.getAttribute(name.toString()) || nil;`
    end

    def []=(name, value)
      `self.$el.setAttribute(name.toString(), '' + value);`
      value
    end
  end
end


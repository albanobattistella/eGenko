public class SimpleList<T> : Object {
    private class Element<T> : Object {
        public T data;
        public Element<T>? next;
        public unowned Element<T>? prev;
    }
    
    private Element<T>? root;
    
    public void clear() {
        root = null;
    }
    
    public new T? @get(int n) {
        return get_nth_element(n).data;
    }
    
    private unowned Element<T> get_nth_element(int n) {
        assert(root != null);
        if (n == 0) {
            return root;
        }
        unowned Element<T>? e = root;
        for (int i = 0; i < n; i++) {
            e = e.next;
            assert(e != null);
        }
        return e;
    }
    
    public int size {
        get {
            if (root == null) {
                return 0;
            } else {
                int len = 0;
                unowned Element<T>? e = root;
                do {
                    len++;
                    e = e.next;
                } while (e != null);
                return len;
            }
        }
    }
    
    public bool is_empty() {
        return size == 0;
    }
    
    public SimpleList.from_data(T new_data, ...) {
        root = new Element<T>() { data = new_data };
        var l = va_list();
        Element<T> e = root;
        while (true) {
            T? va_data = l.arg();
            if (va_data == null) {
                break;
            } else {
                e.next = new Element<T>() { data = va_data };
                e.next.prev = e;
                e = e.next;
            }
        }
    }

    public SimpleList<T>? cut_at(int n) {
        assert(root != null);
        if (n == 0) {
            return null;
        }
        unowned Element<T>? e = get_nth_element(n - 1);
        Element<T> next_first = e.next;
        e.next = null;
        SimpleList<T> new_list = new SimpleList<T>();
        new_list.root = next_first;
        return new_list;
    }
    
    public T get_last() {
        return get_last_element().data;
    }
    
    private unowned Element<T> get_last_element() {
        assert(root != null);
        unowned Element<T> e = root;
        while (e.next != null) {
            e = e.next;
        }
        return e;
    }
    
    public void add(T new_element) {
        if (root == null) {
            root = new Element<T>() { data = new_element };
        } else {
            Element<T> e = get_last_element();
            e.next = new Element<T>() { data = new_element };
            e.next.prev = e;
        }
    }
    
    public void add_all(SimpleList<T> list) {
        if (size == 0) {
            root = list.root;
        } else {
            Element<T> last = get_last_element();
            last.next = list.root;
            last.next.prev = last;
        }
        list.clear();
    }
    
    public void insert(int index, T new_data) {
        if (root == null) {
            if (index == 0) {
                root = new Element<T>() { data = new_data };
            } else {
                return;
            }
        } else {
            if (index == 0) {
                Element<T> e = new Element<T>() { data = new_data };
                e.next = root;
                e.next.prev = root;
                root = e;
            } else {
                Element<T>? e = get_nth_element(index - 1);
                Element<T> new_elem = new Element<T>() { data = new_data };
                new_elem.next = e.next;
                if (e.next != null) {
                    new_elem.next.prev = new_elem;
                }
                e.next = new_elem;
                new_elem.prev = e;
            }
        }
    }
    
    public void insert_all(int index, SimpleList<T> new_elements) {
        if (new_elements.is_empty()) {
            return;
        } else if (root == null && index == 0) {
            root = new_elements.root;
        } else {
            if (index == 0) {
                new_elements.get_last_element().next = root;
                root = new_elements.root;
            } else {
                Element<T>? e1 = get_nth_element(index - 1);
                if (e1.next == null) {
                    e1.next = new_elements.root;
                } else {
                    Element<T>? e2 = e1.next;
                    Element<T>? e3 = new_elements.get_last_element();
                    e3.next = e2;
                    if (e3.next != null) {
                        e3.next.prev = e3;
                    }
                    e1.next = new_elements.root;
                    e1.next.prev = e1;
                }
            }
        }
        new_elements.clear();
    }
    
    public T? remove_at(int index) {
        assert(root != null);
        if (index == 0) {
            if (root.next != null) {
                Element<T> e1 = root.next;
                Element<T> e2 = root;
                root.next = null;
                root = e1;
                return e2.data;
            } else {
                Element<T> e = root;
                root = null;
                return e.data;
            }
        } else {
            Element<T>? e = get_nth_element(index - 1);
            assert(e.next != null);;
            Element<T>? e2 = e.next;
            Element<T>? e3 = e.next.next;
            e.next = e3;
            return e2.data;
        }
    }
    
    public SimpleList<T>? remove(int start_index, int num_to_remove) {
        assert(start_index >= 0);
        SimpleList<T> list = new SimpleList<T>();
        int max = size;
        if (start_index == 0) {
            if (num_to_remove < max) {
                Element<T> e = get_nth_element(num_to_remove);
                list.root = root;
                e.prev.next = null;
                root = e;
                e.prev = null;
            } else {
                list.root = root;
                root = null;
            }
        } else {
            if (start_index + num_to_remove < max) {
                Element<T> e1 = get_nth_element(start_index - 1);
                Element<T> e2 = get_nth_element(start_index + num_to_remove);
                Element<T> e3 = e1.next;
                e3.prev = null;
                list.root = e3;
                e1.next = e2;
                e2.prev.next = null;
                e2.prev = e1;
            } else {
                Element<T> e1 = get_nth_element(start_index - 1);
                list.root = e1.next;
                e1.next.prev = null;
                e1.next = null;
            }
        }
        return list;
    }
    
    public SimpleList<T>? slice_cut(int start_index, int end_index) {
        return remove(start_index, end_index - start_index);
    }
}

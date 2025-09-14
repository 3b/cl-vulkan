
(defclass clui-window (clui:window)
  ())

(defclass vulkan-helper-window (clui::handle-mixin)
  ((surface :initform nil :accessor render-surface)
   (surface-format :initform nil :accessor surface-format)
   (render-pass :initform nil :accessor render-pass)))

(defmethod wait-events ((window clui-window))
  (clui::wait-events (clui::window-display window)))

(defmethod window-framebuffer-size ((window clui-window))
  (clui:window-framebuffer-size window))

(defmethod clim:handle-event ((window vulkan-window-mixin) (event clui::window-resize-event-mixin))
  (let ((width (clui::window-resize-event-new-width event))
	(height (clui::window-resize-event-new-height event)))
    (unless (or (zerop width) (zerop height))
      (unless (render-surface window)
	(clui::initialize-window-devices window
					 :width width
					 :height height))
      (call-next-method)
      (setf (recreate-swapchain? window) t)
      (setf (window-initialized? window) t)
      (values))))

(defmethod clui::destroy-window ((window vulkan-window))
  (destroy-os-window window))

(defmethod window-display ((window clui-window))
  (clui:window-display window))


(defmethod create-native-window-surface ((window clui-window) instance allocator)
  (clui::create-native-window-surface (clui::window-display window)
                                      (get-vulkan-instance)
                                      window allocator))

(defmethod ptr-value ((window clui-window) pointer)
  (noffi::pointer-value pointer))

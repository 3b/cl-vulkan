(in-package :vk/glfw)

(defun get-required-instance-extensions ()
  (with-foreign-object (p-extension-count :unsigned-int)
    (let ((pp-extensions (glfwGetRequiredInstanceExtensions p-extension-count)))
      (loop for i from 0 below (mem-aref p-extension-count :unsigned-int)
	 collect (foreign-string-to-lisp (mem-aref pp-extensions :pointer i))))))
(defvar *has-init* nil)

(defclass glfw-window ()
  ())

(defmethod initialize-instance :before ((o glfw-window) &key)
  (unless *has-init*
    ;; don't try to initialize again if first time failed
    (setf *has-init* t)
    (when (zerop (glfwInit))
      (error "GLFW failed to initialize."))))

(defclass vulkan-helper-window/glfw ())

(defmethod os-window-should-close-p ((window glfw-window))
  (not (zerop (glfwWindowShouldClose (h window)))))

(defmethod (setf os-window-should-close-p) (value (window glfw-window))
  (glfwSetWindowShouldClose (h window) (if value 1 0)))

(defmethod (setf os-window-title) (title (window glfw-window))
  (glfwSetWindowTitle (h window) title))

(defmethod get-os-window-pos ((window glfw-window))
  (with-foreign-objects ((p-x :int)
			 (p-y :int))
    (glfwGetWindowPos (h window) p-x p-y)
    (values (mem-aref p-x :int)
	    (mem-aref p-y :int))))

(defmethod set-os-window-pos ((window glfw-window) x y)
  (glfwSetWindowPos (h window) (round x) (round y)))

(defmethod get-os-window-cursor-pos ((window glfw-window))
  (with-foreign-objects ((p-x :double)
			 (p-y :double))
    (glfwGetCursorPos (h window) p-x p-y)
    (values (mem-aref p-x :double)
	    (mem-aref p-y :double))))

(defmethod get-os-window-size ((window glfw-window))
  (with-foreign-objects ((p-width :int)
			 (p-height :int))
    (glfwGetWindowSize (h window) p-width p-height)
    (values (mem-aref p-width :int)
	    (mem-aref p-height :int))))

(defmethod focus-os-window ((window glfw-window))
  (glfwFocusWindow (h window)))

(defmethod hide-os-window ((window glfw-window))
  (glfwHideWindow (h window)))

(defmethod show-os-window ((window glfw-window))
  (glfwShowWindow (h window)))

(defmethod maximize-os-window ((window glfw-window))
  (glfwMaximizeWindow (h window)))

(defmethod restore-os-window ((window glfw-window))
  (glfwRestoreWindow (h window)))

(defmethod iconify-os-window ((window glfw-window))
  (glfwIconifyWindow (h window)))

(defmethod get-os-window-frame-size ((window glfw-window))
  (with-foreign-objects ((p-left :int)
			 (p-top :int)
			 (p-right :int)
			 (p-bottom :int))
    (glfwGetWindowFrameSize (h window) p-left p-top p-right p-bottom)
    (values (mem-aref p-left :int) (mem-aref p-top :int)
	    (mem-aref p-right :int) (mem-aref p-bottom :int))))

(defmethod get-os-window-framebuffer-size ((window glfw-window))
  (with-foreign-objects ((p-width :int)
			 (p-height :int))
    (glfwGetFramebufferSize (h window) p-width p-height)
    (values (mem-aref p-width :int) (mem-aref p-height :int))))

(defgeneric window-framebuffer-size ((window glfw-window))
  (get-os-window-framebuffer-size window))

(defmethod set-os-window-size ((window glfw-window) height width)
  (glfwSetWindowSize (h window) height width))

(defmethod set-os-window-aspect-ratio ((window glfw-window) numer denom)
  (glfwSetWindowAspectRatio (h window) numer denom))

(defmethod set-os-window-size-limits ((window glfw-window) min-width min-height max-width max-height)
  (glfwSetWindowSizeLimits (h window) min-width min-height max-width max-height))

(defmethod create-glfw-window-surface (instance (window glfw-window)
                                        &key (allocator +null-allocator+))
  (with-foreign-object (p-surface 'VkSurfaceKHR)
    (check-vk-result (glfwCreateWindowSurface (h instance) (h window) (h allocator) p-surface))
    (let ((surface (make-instance 'surface
				  :handle (mem-aref p-surface 'VkSurfaceKHR)
				  :window window
				  :instance instance
				  :allocator allocator)))
      (setf (render-surface window) surface))))

(defmethod wait-events ((window glfw-window))
  (glfwWaitEvents))

(defmethod window-display ((window glfw-window))
  (break "todo"))

(defun find-window (handle) ;; todo: in the ffi define this slot as int or uint
  (gethash handle (window-registry *app*)
	   :key #'h :test #'pointer-eq))

(defmethod create-native-window-surface ((window glfw-window) instance allocator))

(defmethod ptr-value ((window glfw-window) pointer)
  pointer)

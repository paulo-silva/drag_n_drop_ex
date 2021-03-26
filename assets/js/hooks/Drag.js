import Sortable from 'sortablejs';

export const Drag = {
  mounted() {
    const hook = this;
    const selector = "#" + this.el.id;

    document.querySelectorAll('.dropzone').forEach((dropzone) => {
      new Sortable(dropzone, {
        animation: 50,
        delayOnTouchOnly: true,
        group: 'shared',
        draggable: '.draggable',
        ghostClass: 'sortable-ghost',
        onStart: (event) => {
          hook.pushEventTo(selector, 'dragged', {
            dragged_id: event.item.id,
            dropzone_id: event.to.id,
            draggable_index: event.newDraggableIndex
          });
        },
        onEnd: (event) => {
          hook.pushEventTo(selector, 'dropped', {
            dragged_id: event.item.id,
            dropzone_id: event.to.id,
            draggable_index: event.newDraggableIndex,
          });
        }
      });
    });
  }
};

export default Drag;

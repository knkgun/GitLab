export default {
  inject: ['vscrollParent'],
  props: {
    index: {
      type: Number,
      required: true,
    },
  },
  watch: {
    index: {
      handler() {
        const { index } = this;

        if (index < 0) return;

        if (this.vscrollParent.itemsWithSize[index].size) {
          this.scrollToIndex(index);
        } else {
          this.$_itemsWithSizeWatcher = this.$watch('vscrollParent.itemsWithSize', async () => {
            await this.$nextTick();

            if (this.vscrollParent.itemsWithSize[index].size) {
              this.$_itemsWithSizeWatcher();
              this.scrollToIndex(index);
            }
          });
        }
      },
      immediate: true,
    },
  },
  beforeDestroy() {
    if (this.$_itemsWithSizeWatcher) this.$_itemsWithSizeWatcher();
  },
  methods: {
    scrollToIndex(index) {
      this.vscrollParent.scrollToItem(index);
    },
  },
  render(h) {
    return h(null);
  },
};

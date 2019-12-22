<template>
  <el-container style="border: 1px solid #eee">
    <!-- aside -->
    <aside-menu />

    <el-container class="main-container">
      <!-- header -->
      <header-menu />
      <!-- main -->
      <el-main>
        <transition name="fade" mode="out-in">
          <!-- main -->
          <router-view />
        </transition>
      </el-main>
      <!-- footer -->
      <el-footer></el-footer>
    </el-container>
  </el-container>
</template>


<script>
import AsideMenu from '@/components/Aside/index.vue'
import HeaderMenu from '@/components/Header/index.vue'

export default {
  components: {
    AsideMenu,
    HeaderMenu
  }
}
</script>

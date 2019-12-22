<template>
  <el-container style="border: 1px solid #eee">
      <!-- main -->
      <el-main>
        <transition name="fade" mode="out-in">
          <!-- main -->
          <router-view />
        </transition>
      </el-main>
  </el-container>
</template>
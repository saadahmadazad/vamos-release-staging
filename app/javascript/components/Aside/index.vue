<template>
  <el-aside class="sidebar-container" width="200px" style="background-color: rgb(238, 241, 246)">
    <el-menu background-color="#545c64"
             :default-openeds="['1', '4']">
      <el-menu-item index="1">
        <template slot="title">
          <router-link to="/system/dashboard">
            <i class="fa fa-calendar"></i>
            <span>ダッシュボード</span>
          </router-link>
        </template>
      </el-menu-item>
      <el-menu-item index="2">
        <template slot="title">
          <router-link to="/system/facility">
            <i class="fa fa-building"></i>
            <span>施設管理</span>
          </router-link>
        </template>
      </el-menu-item>
      <el-menu-item index="3">
        <template slot="title">
          <router-link to="/system/ota">
            <i class="fa fa-cogs"></i>
            <span>OTA管理</span>
          </router-link>
        </template>
      </el-menu-item>
      <el-menu-item index="4">
        <template slot="title">
          <router-link to="/system/room">
            <i class="fa fa-bed"></i>
            <span>部屋管理</span>
          </router-link>
        </template>
      </el-menu-item>
    </el-menu>
  </el-aside>
</template>


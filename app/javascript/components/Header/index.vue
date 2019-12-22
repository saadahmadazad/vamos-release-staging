<template>
  <el-row>
    <!-- menu -->
    <el-col :span="24" class="navbar__menu-box">
      <el-menu class="el-menu-header" mode="horizontal">
        <el-menu-item index="1">
          <i class="el-icon-menu"></i>
        </el-menu-item>
        <el-submenu index="2">
          <template slot="title">
            <!-- {{$auth.user.name}} -->
            {{ $auth.user().name }}
            <el-image class="user-icon" :src="url"></el-image>
          </template>
          <el-menu-item index="2-1">
            <router-link class="header_menu" to="/system/user/">
              <i class="el-icon-user"></i>会員管理</router-link>
          </el-menu-item>
          <el-menu-item index="2-2" @click="$auth.logout()">ログアウト</el-menu-item>
        </el-submenu>
        <!-- 通知 -->
        <el-submenu index="3">
          <template slot="title">
            通知
            <i class="el-icon-bell"></i>
          </template>
          <el-menu-item index="3-1">
            <router-link class="header_menu" to="/">
              <i class="el-icon-message-solid"></i>Message XXXXXXXX
            </router-link>
          </el-menu-item>
          <el-menu-item index="3-2">
            <router-link class="header_menu" to="/">
              <i class="el-icon-message-solid"></i>Message XXXXXXXX
            </router-link>
          </el-menu-item>
          <el-menu-item index="3-3">
            <router-link class="header_menu" to="/">
              <i class="el-icon-message-solid"></i>Message XXXXXXXX
            </router-link>
          </el-menu-item>
        </el-submenu>
        <!-- Q&A -->
        <!-- <el-submenu index="4">
          <template slot="title">
            Q&A
            <i class="el-icon-question"></i>
          </template>
        </el-submenu> -->
      </el-menu>
    </el-col>
  </el-row>
</template>

<script>
  export default {
    data() {
      return {
        url: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRn3qmREi6Bag9BxxTvSCdXKqL8G2mBNjSFMi1nBZ1r92jNniSwnw'
      };
    }
  }
</script>

<style>
.user-icon {
  width: 40px;
  height: 40px;
  border-radius:50px
}

.el-menu--horizontal>.el-submenu {
  float: right !important;
}

.header_menu {
  color: #909399 !important;
}
</style>
ThisBuild / organization := "com.example"

ThisBuild / scalaVersion := "2.13.4"
ThisBuild / scalacOptions ++= Seq("-deprecation", "-feature", "-unchecked", "-Xlint")

lazy val hello = (project in file("."))
  .settings(
    name := "Hello",
    libraryDependencies += "org.scalatest" %% "scalatest" % "3.2.6" % Test,
  )

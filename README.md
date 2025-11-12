<img alt="icon" src=".diploi/icon.svg" width="32">

# Next.js Component for Diploi

[![launch with diploi badge](https://diploi.com/launch.svg)](https://diploi.com/component/next)
[![component on diploi badge](https://diploi.com/component.svg)](https://diploi.com/component/next)
[![latest tag badge](https://badgen.net/github/tag/diploi/component-nextjs)](https://diploi.com/component/next)

Launch a trial, no account needed
https://diploi.com/component/next

Uses the official [node](https://hub.docker.com/_/node) Docker image.

## Operation

### Getting started

1. In the Dashboard, click **Create Project +**
2. Under **Pick Components**, choose **Next.js**

   You can add other frameworks from this page if you want to create a monorepo application, eg, Next.js + Bun for backend.
3. In **Pick Add-ons**, select any databases or extra tools you need.
4. Choose **Create Repository** so Diploi generates a new GitHub repo for your project.
5. Click **Launch Stack**

Check the guide https://diploi.com/blog/hosting_nextjs_apps

### Development

Will run `npm install` when component is first initialized, and `npm run dev` when deployment is started.

### Production

Will build a production ready image. Image runs `npm install` & `npm build` when being created. Once the image runs, `npm start` is called.

## Links

- [Adding Next.js to a project](https://docs.diploi.com/building/components/nextjs)
- [Next.js documentation](https://nextjs.org/docs)

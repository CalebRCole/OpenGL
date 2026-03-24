#include <glad/glad.h>

#include <GLFW/glfw3.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define WIDTH 800
#define HEIGHT 600

void error_callback(int error, const char* description)
{
    fprintf(stderr, "GLFW Error (%d): %s\n", error, description);
}

void framebuffer_size_callback(GLFWwindow* window, int width, int height)
{
  (void)window;
  glViewport(0, 0, width, height);
};

int main() {
  glfwSetErrorCallback(error_callback);

  if (!glfwInit())
    {
      printf("Failed to initialize GLFW\n");
      return EXIT_FAILURE;
    }

  glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
  glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
  glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

  GLFWwindow* window = glfwCreateWindow(WIDTH, HEIGHT, "LearnOpenGL", nullptr, nullptr);
  if (window == nullptr)
    {
      printf("Failed to create GLFW window\n");
      glfwTerminate();
      return EXIT_FAILURE;
    }
  glfwMakeContextCurrent(window);
  glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);


  if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
    {
      printf("Failed to initialize GLAD\n");
      return EXIT_FAILURE;
    }

  glViewport(0, 0, WIDTH, HEIGHT);

  while (!glfwWindowShouldClose(window))
    {
      glfwSwapBuffers(window);
      glfwPollEvents();
    }

  glfwTerminate();

  return EXIT_SUCCESS;
}

attribute vec3 point;
uniform mat4 transform;

void main(void)
{
    gl_Position = transform*vec4(point, 1.0);
}
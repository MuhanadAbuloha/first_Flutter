package org.acme.entity;

import jakarta.transaction.Transactional;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

import java.net.URI;
import java.util.List;
import java.util.Objects;

@Path(SystemPaths.MAIN)
public class UserResource {


    @GET
    @Path(SystemPaths.ALLUSERS)
    @Produces(MediaType.APPLICATION_JSON)
    public Response getAllUsers() {
        List<User> userList = User.listAll();
        return Response.ok(userList).build();
    }

    @POST
    @Path(SystemPaths.SIGNUP)
    @Transactional
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response signUp(User user) {
        if(User.findByName(user.getUsername())==null){
            User.persist(user);
            if (user.isPersistent()) {
                return Response.created(URI.create("/users/" + user.id)).build();
            } else {
                return Response.status(Response.Status.BAD_REQUEST).build();
            }
        }else {
             return Response.status(Response.Status.NOT_FOUND).build();
        }
    }


    @POST
    @Path(SystemPaths.LOGIN)
    @Transactional
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response Login(LoginRequest login) {  //note errors
        String userName = login.getUsername();
        String password = login.getPassword();
        User user = User.findByUsernameAndPassword(userName, password);
        if (user!=null) {
            return Response.ok(user).build();
        } else {
            return Response.status(Response.Status.BAD_REQUEST).build();
        }
    }

    @PUT
    @Path("{id}")
    @Transactional
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public Response updateUser(@PathParam("id") Long id, User updatedUser) {

        User dbUser = User.findById(id);
        if(User.findByName(updatedUser.getUsername())==null){

        String userName = updatedUser.getUsername();
        String password = updatedUser.getPassword();
        boolean isAdmin=updatedUser.getAdmin();


            if (Objects.nonNull(userName)) {
                dbUser.setUsername(userName);

            }
            if (Objects.nonNull(password)) {
                dbUser.setPassword(password);
            }
            if (Objects.nonNull(isAdmin)) {
            dbUser.setAdmin(isAdmin);
            }

            dbUser.persist();
            if (dbUser.isPersistent()) {
                return Response.ok(dbUser).build();
            } else {
                return Response.status(Response.Status.BAD_REQUEST).build();
            }}else{
                return Response.status(Response.Status.NOT_FOUND).build();
            }

        }

    @DELETE
    @Path("/{id}")
    @Transactional
    @Produces(MediaType.APPLICATION_JSON)
    public Response deleteUser(@PathParam("id") Long id) {
        boolean isDeleted = User.deleteById(id);
        User user = User.findById(id);
        if (isDeleted) {
            return Response.noContent().build();
        } else {
            return Response.status(Response.Status.BAD_REQUEST).build();
        }
    }
}

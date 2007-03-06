%{
#ifndef H_SYNTREE
#define H_SYNTREE

#include "syn_typedefs.h"
%}
%{
#ifndef NDEBUG
#   define NDEBUG
#   define NDEBUG_WAS_NOT_DEFINED
#endif

#include "syntree.h"

#include <config.h>
#include <rose.h>

#include "pignodelist.h"
%}

%%
extern_c get:head(NODE, TYPE, CONSTR, _, FIELD, _, FTYPE)
%{
FTYPE TYPE##_##CONSTR##_get_##FIELD(TYPE NODE)
%}

/* do something for all nonterminals (marked NT) */
get:body(NODE, "ExpressionRootNT", _, _, FIELD, _, _)
%{
    return isSgExpressionRoot((SgNode *) NODE)->get_##FIELD();
%}

get:body(NODE, _, "UndeclareStmt", _, "vars", _, _)
%{
    return new PigNodeList(*((UndeclareStmt *) NODE)->get_vars());
%}
get:body(NODE, _, "DeclareStmt" | "UndeclareStmt", _, FIELD, _, _)
%{
    CONSTR *stmt = dynamic_cast<CONSTR *>((SgNode *) NODE);
    return (void *) stmt->get_##FIELD();
%}

get:body(NODE, _, "ExternalCall" | "ConstructorCall" | "DestructorCall", _, FIELD, _, _)
%{
    CONSTR *stmt = dynamic_cast<CONSTR *>((SgNode *) NODE);
    return stmt->get_##FIELD();
%}

get:body(NODE, _, "FunctionExit"|"FunctionCall"|"FunctionReturn", _, "params", _, _)
%{
    if (((CallStmt *) NODE)->parent->paramlist != NULL)
        return new PigNodeList(*((CallStmt *) NODE)->parent->paramlist);
    else
        return NULL;
%}

get:body(NODE, _, "FunctionEntry" | "FunctionExit" | "FunctionCall" | "FunctionReturn" , _, FIELD, _, _)
%{
    CONSTR *stmt = dynamic_cast<CONSTR *>((SgNode *) NODE);
    return stmt->get_##FIELD();
%}

get:body(NODE, _, "ArgumentAssignment" | "ParamAssignment" | "ReturnAssignment" | "LogicalIf" | "IfJoin" | "WhileJoin", _, FIELD, _, _)
%{
    CONSTR *assignment = dynamic_cast<CONSTR *>((SgNode *) NODE);
    return assignment->get_##FIELD();
%}

get:body(NODE, _, "ScopeStatement", _, "node", _, _)
%{
    return NODE;
%}

get:body(NODE, _, "VarRefExp" | "InitializedName", _, "name", _, _)
%{
    SgInitializedName *in = isSgInitializedName((SgNode *) NODE);
    if (in == NULL && isSgVarRefExp((SgNode *) NODE))
        in = isSgVarRefExp((SgNode *) NODE)->get_symbol()->get_declaration();
    if (in != NULL)
        if (in->get_scope() != NULL)
            return strdup(in->get_qualified_name().str());
        else
            return strdup(in->get_name().str());
    else
        return NULL;
%}

get:body(NODE, _, "VariableSymbol", _, "name", _, _)
%{
    SgVariableSymbol *var = isSgVariableSymbol((SgNode *) NODE);
    if (var->get_declaration()->get_scope() != NULL)
        return strdup(var->get_declaration()->get_qualified_name().str());
    else
        return strdup(var->get_declaration()->get_name().str());
%}

get:body(NODE, _, "BasicType", _, "typename", _, _)
%{
    return basic_type_name(NODE);
%}

get:body(NODE, _, "NamedType", _, "name", _, _)
%{
    SgNamedType *type = isSgNamedType((SgNode *) NODE);
    return strdup(type->get_name().str());
%}

/* lists */
get:body(NODE, _, _, _, "declarations", _, FTYPE)
%{
    return (void *) new PigNodeList(
        isSg##CONSTR((SgNode *) NODE)->get_##FIELD());
%}

get:body(NODE, _, _, _, "args", _, FTYPE)
%{
    return (void *) new PigNodeList(
        isSg##CONSTR((SgNode *) NODE)->get_##FIELD());
%}

get:body(NODE, _, _, _, "arguments", _, FTYPE)
%{
    return (void *) new PigNodeList(
        isSg##CONSTR((SgNode *) NODE)->get_##FIELD());
%}

get:body(NODE, _, _, _, "ctors", _, FTYPE)
%{
    return (void *) new PigNodeList(
        isSg##CONSTR((SgNode *) NODE)->get_##FIELD());
%}

get:body(NODE, _, "ForInitStatement", _, "init_stmt", _, FTYPE)
%{
    return (void *) new PigNodeList(
        isSg##CONSTR((SgNode *) NODE)->get_##FIELD());
%}

get:body(NODE, _, "VariableDeclaration", _, "variables", _, FTYPE)
%{
    return (void *) new PigNodeList(
        isSg##CONSTR((SgNode *) NODE)->get_##FIELD());
%}

get:body(NODE, _, "ExprListExp", _, "expressions", _, FTYPE)
%{
    return (void *) new PigNodeList(
        isSg##CONSTR((SgNode *) NODE)->get_##FIELD());
%}

get:body(NODE, _, "StringVal", _, "value", _, _)
%{
    return strdup(isSg##CONSTR((SgNode *) NODE)->get_value().c_str());
%}

get:body(NODE, _, CONSTR, _, "value", _, _)
%{
    return isSg##CONSTR((SgNode *) NODE)->get_value();
%}

get:body(NODE, _, CONSTR, _, FIELD, _, _)
%{
    return (void *) isSg##CONSTR((SgNode *) NODE)->get_##FIELD();
%}

%%
extern_c per_constructor is:head(NODE, TYPE, CONSTR, _, _, _, _)
%{
int is_op_##TYPE##_##CONSTR(TYPE NODE)
%}

is:body(NODE, _, "DeclareStmt" | "UndeclareStmt", _, _, _, _)
%{
    return dynamic_cast<CONSTR *>(isSgStatement((SgNode *) NODE)) != NULL;
%}

is:body(NODE, _, "ExpressionRootNT", _, _, _, _)
%{
    return isSgExpressionRoot((SgNode *) NODE) != NULL;
%}

is:body(NODE, _, "ExternalCall" | "ConstructorCall" | "DestructorCall", _, _, _, _)
%{
    CONSTR *e = dynamic_cast<CONSTR *>(isSgStatement((SgNode *) NODE));
    return e != NULL;
%}

is:body(NODE, _, "FunctionEntry" | "FunctionExit" | "FunctionCall" | "FunctionReturn", _, _, _, _)
%{
    CONSTR *e = dynamic_cast<CONSTR *>(isSgStatement((SgNode *) NODE));
    return e != NULL && e->parent != NULL
        && e->parent->node_type == (enum KFG_NODE_TYPE) X_##CONSTR;
%}

is:body(NODE, _, "ArgumentAssignment" | "ParamAssignment" | "ReturnAssignment" | "LogicalIf" | "IfJoin" | "WhileJoin", _, _, _, _)
%{
    return dynamic_cast<CONSTR *>(isSgStatement((SgNode *) NODE)) != NULL;
%}

is:body(NODE, _, "BasicType", _, _, _, _)
%{
    return basic_type_name(NODE) != NULL;
%}

is:body(NODE, _, CONSTR, _, _, _, _)
%{
    return isSg##CONSTR((SgNode *) NODE) != NULL;
%}

%{
#include "pag_support.h"

#endif
%}
%{
//#include "pag_support.c"

#ifdef NDEBUG_WAS_NOT_DEFINED
#   undef NDEBUG
#endif
%}
